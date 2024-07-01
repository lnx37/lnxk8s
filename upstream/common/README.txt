kubeadm 1.29.4

kubeadm init \
  --apiserver-advertise-address=172.22.25.206 \
  --control-plane-endpoint=172.22.25.206 \
  --image-repository=registry.aliyuncs.com/google_containers \
  --kubernetes-version=v1.29.2 \
  --pod-network-cidr=10.244.0.0/16 \
  --service-cidr=10.96.0.0/12 \
  --upload-certs \
  --dry-run \
  >kubeadm_init_dry_run.log

kubeadm init \
  --apiserver-advertise-address=172.22.25.208 \
  --control-plane-endpoint=172.22.25.208 \
  --image-repository=registry.aliyuncs.com/google_containers \
  --kubernetes-version=v1.29.2 \
  --pod-network-cidr=10.244.0.0/16 \
  --service-cidr=10.96.0.0/12 \
  --upload-certs \
  >kubeadm_init.log

kubectl -n kube-system get cm kubeadm-config -o yaml >kubeadm_config.yml

kubeadm reset -f >kubeadm_reset.log
