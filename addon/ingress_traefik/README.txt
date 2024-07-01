KUBERNETES INGRESS TRAEFIK, 202405

https://github.com/traefik/traefik-helm-chart
https://artifacthub.io/packages/helm/traefik/traefik/
https://artifacthub.io/packages/helm/traefik/traefik/?modal=values
https://doc.traefik.io/traefik/getting-started/install-traefik/#use-the-helm-chart

helm repo add traefik https://traefik.github.io/charts
helm repo update

helm install traefik traefik/traefik
helm uninstall traefik

cat <<EOF >value.yml
hostNetwork: false
ports:
  traefik:
    hostPort: 9000
  web:
    hostPort: 80
  websecure:
    hostPort: 443
EOF
helm install traefik traefik/traefik -f value.yml
helm uninstall traefik

kubectl get all -A |grep "traefik"
