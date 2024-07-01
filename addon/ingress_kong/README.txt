KUBERNETES INGRESS KONG, 202406

https://github.com/Kong/charts
https://artifacthub.io/packages/helm/kong/kong
https://artifacthub.io/packages/helm/kong/kong?modal=values
https://docs.konghq.com/kubernetes-ingress-controller/latest/get-started/

helm repo add kong https://charts.konghq.com
helm repo update

helm install kong kong/ingress -n kong --create-namespace
helm uninstall kong -n kong

kubectl get all -n kong
