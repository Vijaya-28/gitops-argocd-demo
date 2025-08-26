# Demo Notes / Script (2–3 minutes)

1) **Intro (10s):**
   - "This is a GitOps pipeline with ArgoCD on Kubernetes. ArgoCD continuously syncs the cluster state from a Git repo."

2) **Show ArgoCD UI (30s):**
   - App: `nginx-app` (Healthy, Synced)
   - Briefly show tree view (Deployment and Service).

3) **Make a Git change (45s):**
   - Edit `app/deployment.yaml` image tag from `nginx:1.25` to `nginx:1.27`, commit & push.
   - Explain that Git is the single source of truth.

4) **Observe Auto-Sync (45s):**
   - In ArgoCD, show the sync triggering automatically.
   - Show new ReplicaSet and updated Pods.

5) **Verify in Cluster (20s):**
   - Run `kubectl get pods` and `kubectl describe deploy nginx-deployment`.
   - Optionally: `minikube service nginx-service` to open the app.

6) **Wrap-up (10s):**
   - "With GitOps, rollbacks are just a `git revert` away. We get auditability, consistency, and reduced drift."
