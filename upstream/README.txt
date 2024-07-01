kubeadm 1.28.2

kubeadm init \
  --apiserver-advertise-address=172.22.25.135 \
  --control-plane-endpoint=172.22.25.135 \
  --image-repository=registry.aliyuncs.com/google_containers \
  --kubernetes-version=v1.28.2 \
  --pod-network-cidr=10.244.0.0/16 \
  --service-cidr=10.96.0.0/12 \
  --upload-certs
--------------------------------------------------------------
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

kubeadm join 172.22.25.135:6443 --token dpfviu.7cli7xee0b67lp8w \
  --discovery-token-ca-cert-hash sha256:e9f5ffb59d3134053cb30e69b088ca6ec90f53a290771a6ed135d2409fd5ce45 \
  --control-plane --certificate-key ef5f310ef7824e48ed3e9978d9d190b7f536acb7382e20201db5d49610d17384

kubeadm join 172.22.25.135:6443 --token dpfviu.7cli7xee0b67lp8w \
  --discovery-token-ca-cert-hash sha256:e9f5ffb59d3134053cb30e69b088ca6ec90f53a290771a6ed135d2409fd5ce45
--------------------------------------------------------------

https://github.com/kubernetes/kubeadm/blob/main/docs/design/design_v1.10.md

---

kubeadm 1.29.4

kubeadm init \
  --apiserver-advertise-address=172.22.25.135 \
  --control-plane-endpoint=172.22.25.135 \
  --image-repository=registry.aliyuncs.com/google_containers \
  --kubernetes-version=v1.29.4 \
  --pod-network-cidr=10.244.0.0/16 \
  --service-cidr=10.96.0.0/12 \
  --upload-certs
--------------------------------------------------------------
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

kubeadm join 172.22.25.135:6443 --token dpfviu.7cli7xee0b67lp8w \
  --discovery-token-ca-cert-hash sha256:e9f5ffb59d3134053cb30e69b088ca6ec90f53a290771a6ed135d2409fd5ce45 \
  --control-plane --certificate-key ef5f310ef7824e48ed3e9978d9d190b7f536acb7382e20201db5d49610d17384

kubeadm join 172.22.25.135:6443 --token dpfviu.7cli7xee0b67lp8w \
  --discovery-token-ca-cert-hash sha256:e9f5ffb59d3134053cb30e69b088ca6ec90f53a290771a6ed135d2409fd5ce45
--------------------------------------------------------------

https://github.com/kubernetes/kubeadm/blob/main/docs/design/design_v1.10.md
