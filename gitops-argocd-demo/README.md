# GitOps Workflow using ArgoCD on Kubernetes

Automate Kubernetes app deployment using **GitOps** with **ArgoCD** and **GitHub**. This repo contains a sample NGINX app, Kubernetes manifests, and an ArgoCD `Application` definition to sync from this Git repository.

## 🧰 Tools
- Minikube or K3s
- kubectl, Git
- ArgoCD (free, installed in-cluster)
- (Optional) Docker, if you want to build your own image

---

## 🚀 Quick Start

### 1) Create a local Kubernetes cluster
**Minikube** example:
```bash
minikube start --memory=4g --cpus=2
kubectl get nodes
```

(or use K3s on a VM)

### 2) Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd get pods
```

Expose the ArgoCD API/UI in a separate terminal:
```bash
./scripts/port-forward-argocd.sh
```
Then open http://localhost:8080

Get the initial admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```
Login with **username:** `admin` and the decoded **password**.

---

## 📦 App Manifests
The sample app is a simple NGINX Deployment with a NodePort Service.

```
app/
├── deployment.yaml
├── service.yaml
└── kustomization.yaml   # lets you `kubectl apply -k app/` if needed
```

You can deploy these directly (imperatively) if you want to verify them outside ArgoCD:
```bash
kubectl apply -k app/
kubectl get pods,svc
```

---

## 🔁 Configure ArgoCD (GitOps)

You have **two ways** to register the app in ArgoCD:

### A) Via ArgoCD UI (recommended for demo)
1. Go to **NEW APP**.
2. **Application Name:** `nginx-app`
3. **Project:** `default`
4. **Repository URL:** your GitHub repo URL (after you push this repo)
5. **Revision:** `main`
6. **Path:** `app`
7. **Cluster URL:** `https://kubernetes.default.svc`
8. **Namespace:** `default`
9. **Sync Policy:** enable **Automated** (Prune + Self Heal optional)

Click **Create**. ArgoCD will sync and deploy.

### B) Via GitOps (ArgoCD `Application` manifest)
Edit `argocd/application.yaml` and replace `REPLACE_WITH_YOUR_REPO_URL` with your repo URL, then:
```bash
kubectl apply -f argocd/application.yaml -n argocd
```

Check the ArgoCD UI to see the app and sync status.

---

## 🔧 Make a Change (See GitOps in Action)

Update the NGINX version in `app/deployment.yaml`, commit & push:
```bash
# in app/deployment.yaml change: image: nginx:1.25 -> image: nginx:1.27
git add app/deployment.yaml
git commit -m "chore: upgrade nginx to 1.27"
git push origin main
```

In the ArgoCD UI, observe **Auto-Sync** applying the change and rollout of new Pods.

---

## 🧾 Deliverables Checklist
- ✅ **Git repo** with manifest files (this repo)
- ✅ **ArgoCD screenshots** showing:
  - App **Healthy/Synced**
  - **History** after the image version update
  - `kubectl get pods` showing the new ReplicaSet/Pods
- ✅ **Video/notes** explaining the GitOps flow (see `NOTES.md`)

---

## 📄 Resume Line
> Implemented a GitOps pipeline using ArgoCD and Kubernetes to auto-sync application deployments from Git, enabling version-controlled rollouts and environment drift detection.

---

## 🛡️ Cleanup
```bash
kubectl delete -f argocd/application.yaml -n argocd || true
kubectl delete -k app/ || true
minikube delete  # if you used Minikube
```
