KUBERNETES DASHBOARD, 202403

https://github.com/kubernetes/dashboard
https://github.com/kubernetes/dashboard/releases
https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard

helm repo add k8s-dashboard https://kubernetes.github.io/dashboard

helm install my-kubernetes-dashboard k8s-dashboard/kubernetes-dashboard --version 7.1.2 --create-namespace --namespace kubernetes-dashboard
helm delete my-kubernetes-dashboard --namespace kubernetes-dashboard

kubectl -n kubernetes-dashboard get svc
kubectl -n kubernetes-dashboard port-forward svc/my-kubernetes-dashboard-kong-proxy 8443:443
kubectl edit svc my-kubernetes-dashboard-kong-proxy -n kubernetes-dashboard

# crictl pull docker.io/kubernetesui/dashboard-api:1.2.0
# crictl pull docker.io/kubernetesui/dashboard-auth:1.1.0
# crictl pull docker.io/kubernetesui/dashboard-metrics-scraper:1.1.1
# crictl pull docker.io/kubernetesui/dashboard-web:1.2.1
# crictl pull docker.io/library/kong:3.6
#
# crictl pull m.daocloud.io/docker.io/kubernetesui/dashboard-api:1.2.0
# crictl pull m.daocloud.io/docker.io/kubernetesui/dashboard-auth:1.1.0
# crictl pull m.daocloud.io/docker.io/kubernetesui/dashboard-metrics-scraper:1.1.1
# crictl pull m.daocloud.io/docker.io/kubernetesui/dashboard-web:1.2.1
# crictl pull m.daocloud.io/docker.io/library/kong:3.6

-----------------------------
cat <<EOF >dashboard_rbac.yml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard

---

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF
-----------------------------

kubectl apply -f dashboard_rbac.yml
kubectl delete -f dashboard_rbac.yml

# kubectl -n NAMESPACE create token SERVICE_ACCOUNT
kubectl -n kubernetes-dashboard create token admin-user

kubectl get all -n kubernetes-dashboard

kubectl -n kubernetes-dashboard delete serviceaccount admin-user
kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user
