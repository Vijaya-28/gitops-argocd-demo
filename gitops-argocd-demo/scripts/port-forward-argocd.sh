#!/usr/bin/env bash
set -euo pipefail
echo "[*] Port-forwarding ArgoCD server to https://localhost:8080 (-> svc/argocd-server:443)"
kubectl -n argocd port-forward svc/argocd-server 8080:443
