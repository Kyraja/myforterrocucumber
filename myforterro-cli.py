#!/usr/bin/env python3
"""
MyForterro API CLI — Client Credentials flow for Linux/Unix shells.

Prints raw JSON to stdout so you can pipe everything into `jq`.
All logs, errors, and debug info go to stderr.

Dependencies: none (Python 3.7+ stdlib only).

--------------------------------------------------------------------
Quickstart

    # 1. Make executable
    chmod +x myforterro-cli.py

    # 2. Set credentials once per shell
    export MFT_CLIENT_ID='3f0ec55a-...'
    export MFT_CLIENT_SECRET='eSdrk9gq...'

    # 3. Use subcommands
    ./myforterro-cli.py token --decode
    ./myforterro-cli.py tenants | jq -r '.[].tenantId'
    ./myforterro-cli.py models --tenant-id abc | jq -r '.data[].id'
    ./myforterro-cli.py chat --tenant-id abc --model gpt-4o-mini \\
        --message "Say OK" | jq -r '.choices[0].message.content'

--------------------------------------------------------------------
Subcommands

  token     Fetch access token via client_credentials grant
  tenants   GET /v1/admin/tenants
  models    GET /v1/ai/inference/openai/models
  chat      POST /v1/ai/inference/openai/chat/completions

All subcommands auto-fetch a token if none is supplied, as long as
MFT_CLIENT_ID + MFT_CLIENT_SECRET (or --client-id/--client-secret) are set.
Supply an existing token via --token or MFT_TOKEN to skip the auth round-trip.

--------------------------------------------------------------------
Environment variables (all optional, flags take precedence)

  MFT_CLIENT_ID          Application ID (OAuth client_id)
  MFT_CLIENT_SECRET      Application secret
  MFT_TOKEN              Reuse an existing access token
  MFT_TENANT_ID          Default tenant for models/chat
  MFT_MODEL              Default model for chat
  MFT_SCOPE              OAuth scope to request in /connect/token
  MFT_TOKEN_URL          Override token endpoint
  MFT_API_BASE           Override API base URL

--------------------------------------------------------------------
Examples with jq

  # Capture just the access_token into a shell variable
  TOKEN=$(./myforterro-cli.py token | jq -r .access_token)
  curl -H "Authorization: Bearer $TOKEN" ...

  # List all model IDs, one per line
  ./myforterro-cli.py models --tenant-id abc | jq -r '.data[].id'

  # Count available models
  ./myforterro-cli.py models --tenant-id abc | jq '.data | length'

  # Chat and print only the answer
  ./myforterro-cli.py chat --tenant-id abc --model gpt-4o-mini \\
      --message "Antworte nur OK" | jq -r '.choices[0].message.content'

  # Chat reading the prompt from stdin
  cat prompt.txt | ./myforterro-cli.py chat --tenant-id abc --model gpt-4o-mini \\
      | jq -r '.choices[0].message.content'

  # Token usage for the last chat
  ./myforterro-cli.py chat --tenant-id abc --model gpt-4o-mini \\
      --message "ping" | jq .usage

  # Check whether a token has the required claims (debugging)
  ./myforterro-cli.py token --decode | jq '.claims | {sub, aud, scope, role, "mf:app_id"}'

--------------------------------------------------------------------
Exit codes

  0   success
  1   HTTP error (non-2xx from MyForterro) — see stderr for details
  2   usage error (missing required flag/env var)
"""

import argparse
import base64
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request


DEFAULT_TOKEN_URL = "https://integration-myforterro-core.fcs-dev.eks.forterro.com/connect/token"
DEFAULT_API_BASE = "https://integration-myforterro-api.fcs-dev.eks.forterro.com"


def log(msg):
    print(msg, file=sys.stderr)


def debug(msg, verbose):
    if verbose:
        print(f"[DEBUG] {msg}", file=sys.stderr)


def err(msg):
    print(f"[ERROR] {msg}", file=sys.stderr)


def warn(msg):
    print(f"[WARN]  {msg}", file=sys.stderr)


def http_request(method, url, headers=None, body=None, verbose=False):
    """Perform an HTTP request. Returns (status, headers_dict, body_text)."""
    req = urllib.request.Request(url, method=method)
    if headers:
        for k, v in headers.items():
            req.add_header(k, v)
    if body is not None:
        if isinstance(body, (dict, list)):
            body = json.dumps(body).encode("utf-8")
            req.add_header("Content-Type", "application/json")
        elif isinstance(body, str):
            body = body.encode("utf-8")

    debug(f"{method} {url}", verbose)
    if headers and verbose:
        for k, v in headers.items():
            display = v[:40] + "..." if len(v) > 40 else v
            debug(f"  {k}: {display}", True)

    try:
        with urllib.request.urlopen(req, data=body) as resp:
            text = resp.read().decode("utf-8", errors="replace")
            debug(f"Response: {resp.status}", verbose)
            return resp.status, dict(resp.headers), text
    except urllib.error.HTTPError as e:
        text = e.read().decode("utf-8", errors="replace")
        debug(f"Response: {e.code}", verbose)
        return e.code, dict(e.headers), text
    except urllib.error.URLError as e:
        err(f"Network error: {e.reason}")
        sys.exit(1)


def decode_jwt(token):
    """Decode a JWT payload without verifying the signature."""
    try:
        parts = token.split(".")
        if len(parts) != 3:
            return None
        payload = parts[1].replace("-", "+").replace("_", "/")
        pad = len(payload) % 4
        if pad:
            payload += "=" * (4 - pad)
        return json.loads(base64.b64decode(payload).decode("utf-8"))
    except Exception as e:
        warn(f"JWT decode failed: {e}")
        return None


def fetch_token(client_id, client_secret, scope, token_url, verbose):
    """POST /connect/token with client_credentials grant. Returns parsed JSON dict."""
    body_params = {
        "grant_type": "client_credentials",
        "client_id": client_id.strip(),
        "client_secret": client_secret.strip(),
    }
    if scope:
        body_params["scope"] = scope.strip()

    body = urllib.parse.urlencode(body_params)
    headers = {"Content-Type": "application/x-www-form-urlencoded"}

    status, resp_headers, text = http_request("POST", token_url, headers, body, verbose)

    if status != 200:
        err(f"Token request failed (status {status})")
        www_auth = resp_headers.get("WWW-Authenticate") or resp_headers.get("www-authenticate")
        if www_auth:
            err(f"WWW-Authenticate: {www_auth}")
        err(f"Body: {text}")
        sys.exit(1)

    try:
        return json.loads(text)
    except json.JSONDecodeError:
        err("Token response is not valid JSON:")
        err(text)
        sys.exit(1)


def resolve_token(args):
    """Return a valid access token.

    Priority: --token flag > MFT_TOKEN env var > auto-fetch via client_id/secret.
    """
    if getattr(args, "token", None):
        return args.token.strip()

    env_token = os.environ.get("MFT_TOKEN", "").strip()
    if env_token:
        return env_token

    client_id = args.client_id or os.environ.get("MFT_CLIENT_ID", "")
    client_secret = args.client_secret or os.environ.get("MFT_CLIENT_SECRET", "")
    if not client_id or not client_secret:
        err("No token available. Set --token / MFT_TOKEN, or provide --client-id/--client-secret (or MFT_CLIENT_ID/MFT_CLIENT_SECRET) to auto-fetch.")
        sys.exit(2)

    scope = args.scope or os.environ.get("MFT_SCOPE", "")
    token_url = args.token_url or os.environ.get("MFT_TOKEN_URL", DEFAULT_TOKEN_URL)

    debug(f"Auto-fetching token from {token_url}", args.verbose)
    data = fetch_token(client_id, client_secret, scope, token_url, args.verbose)
    return data["access_token"]


def handle_api_error(status, resp_headers, text, action):
    """Print a helpful error message for non-2xx API responses and exit."""
    err(f"{action} failed (status {status})")
    www_auth = resp_headers.get("WWW-Authenticate") or resp_headers.get("www-authenticate")
    if www_auth:
        err(f"WWW-Authenticate: {www_auth}")
    if text:
        err(f"Body: {text[:500]}")
    sys.exit(1)


# ── Subcommand implementations ────────────────────────────────────

def cmd_token(args):
    client_id = args.client_id or os.environ.get("MFT_CLIENT_ID", "")
    client_secret = args.client_secret or os.environ.get("MFT_CLIENT_SECRET", "")
    scope = args.scope or os.environ.get("MFT_SCOPE", "")
    token_url = args.token_url or os.environ.get("MFT_TOKEN_URL", DEFAULT_TOKEN_URL)

    if not client_id or not client_secret:
        err("client_id and client_secret are required (--client-id/--client-secret or MFT_CLIENT_ID/MFT_CLIENT_SECRET)")
        sys.exit(2)

    data = fetch_token(client_id, client_secret, scope, token_url, args.verbose)

    if args.decode:
        claims = decode_jwt(data.get("access_token", ""))
        data["claims"] = claims
        if claims:
            expected = ["sub", "aud", "scope", "role", "mf:app_id", "mf:uid"]
            missing = [k for k in expected if k not in claims]
            if missing:
                warn(f"Missing claims: {', '.join(missing)}")

    print(json.dumps(data, indent=2))


def cmd_tenants(args):
    token = resolve_token(args)
    api_base = args.api_base or os.environ.get("MFT_API_BASE", DEFAULT_API_BASE)

    headers = {"Authorization": f"Bearer {token}"}
    status, resp_headers, text = http_request(
        "GET", f"{api_base}/v1/admin/tenants", headers, None, args.verbose
    )

    if status != 200:
        handle_api_error(status, resp_headers, text, "List tenants")

    # Pass-through (already JSON from the server)
    print(text)


def cmd_models(args):
    token = resolve_token(args)
    api_base = args.api_base or os.environ.get("MFT_API_BASE", DEFAULT_API_BASE)
    tenant_id = args.tenant_id or os.environ.get("MFT_TENANT_ID", "")

    if not tenant_id:
        err("tenant_id required (--tenant-id or MFT_TENANT_ID)")
        sys.exit(2)

    headers = {
        "Authorization": f"Bearer {token}",
        "MFT-Tenant-Id": tenant_id.strip(),
    }
    status, resp_headers, text = http_request(
        "GET", f"{api_base}/v1/ai/inference/openai/models", headers, None, args.verbose
    )

    if status != 200:
        handle_api_error(status, resp_headers, text, "List models")

    print(text)


def cmd_chat(args):
    token = resolve_token(args)
    api_base = args.api_base or os.environ.get("MFT_API_BASE", DEFAULT_API_BASE)
    tenant_id = args.tenant_id or os.environ.get("MFT_TENANT_ID", "")
    model = args.model or os.environ.get("MFT_MODEL", "")

    if not tenant_id:
        err("tenant_id required (--tenant-id or MFT_TENANT_ID)")
        sys.exit(2)
    if not model:
        err("model required (--model or MFT_MODEL)")
        sys.exit(2)

    # Message from --message or stdin
    if args.message:
        user_message = args.message
    elif not sys.stdin.isatty():
        user_message = sys.stdin.read().rstrip("\n")
    else:
        err("message required (--message or pipe via stdin)")
        sys.exit(2)

    messages = []
    if args.system:
        messages.append({"role": "system", "content": args.system})
    messages.append({"role": "user", "content": user_message})

    body = {
        "model": model,
        "messages": messages,
    }
    if args.temperature is not None:
        body["temperature"] = args.temperature
    if args.max_tokens is not None:
        body["max_tokens"] = args.max_tokens

    headers = {
        "Authorization": f"Bearer {token}",
        "MFT-Tenant-Id": tenant_id.strip(),
    }
    status, resp_headers, text = http_request(
        "POST",
        f"{api_base}/v1/ai/inference/openai/chat/completions",
        headers,
        body,
        args.verbose,
    )

    if status != 200:
        handle_api_error(status, resp_headers, text, "Chat completion")

    print(text)


# ── Argument parsing ──────────────────────────────────────────────

def build_parser():
    parser = argparse.ArgumentParser(
        prog="myforterro-cli.py",
        description="MyForterro API CLI (Client Credentials flow). Outputs JSON to stdout for piping into jq.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "See the module docstring at the top of this file for a full usage guide "
            "(environment variables, examples, exit codes)."
        ),
    )
    sub = parser.add_subparsers(dest="command", required=True, metavar="COMMAND")

    def add_common(p):
        p.add_argument("--client-id", help="OAuth client ID (overrides MFT_CLIENT_ID)")
        p.add_argument("--client-secret", help="OAuth client secret (overrides MFT_CLIENT_SECRET)")
        p.add_argument("--token-url", help=f"Token endpoint (default: {DEFAULT_TOKEN_URL})")
        p.add_argument("--api-base", help=f"API base URL (default: {DEFAULT_API_BASE})")
        p.add_argument("--scope", help="OAuth scope to request (overrides MFT_SCOPE)")
        p.add_argument("--verbose", "-v", action="store_true", help="Print request/response debug info to stderr")

    p_token = sub.add_parser("token", help="Fetch an access token")
    add_common(p_token)
    p_token.add_argument("--decode", action="store_true", help="Include decoded JWT claims in output under 'claims' key")
    p_token.set_defaults(func=cmd_token)

    p_tenants = sub.add_parser("tenants", help="List available tenants")
    add_common(p_tenants)
    p_tenants.add_argument("--token", help="Existing access token (otherwise auto-fetched)")
    p_tenants.set_defaults(func=cmd_tenants)

    p_models = sub.add_parser("models", help="List available AI models for a tenant")
    add_common(p_models)
    p_models.add_argument("--token", help="Existing access token (otherwise auto-fetched)")
    p_models.add_argument("--tenant-id", help="MFT-Tenant-Id header (overrides MFT_TENANT_ID)")
    p_models.set_defaults(func=cmd_models)

    p_chat = sub.add_parser("chat", help="Send a chat completion")
    add_common(p_chat)
    p_chat.add_argument("--token", help="Existing access token (otherwise auto-fetched)")
    p_chat.add_argument("--tenant-id", help="MFT-Tenant-Id header (overrides MFT_TENANT_ID)")
    p_chat.add_argument("--model", help="Model ID, e.g. gpt-4o-mini (overrides MFT_MODEL)")
    p_chat.add_argument("--message", help="User message. If omitted, read from stdin.")
    p_chat.add_argument("--system", help="Optional system prompt")
    p_chat.add_argument("--temperature", type=float, help="Sampling temperature (0.0 - 2.0)")
    p_chat.add_argument("--max-tokens", type=int, help="Maximum tokens in the response")
    p_chat.set_defaults(func=cmd_chat)

    return parser


def main():
    parser = build_parser()
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
