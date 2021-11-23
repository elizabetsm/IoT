#install 
apt-get update
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
apt install docker
apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get install -y kubectl


export K3D_FIX_DNS=1
export DOCKER_OPTS="--dns=my-private-dns-senver-ip --dns=8.8.8.8" 
k3d cluster create mycluster -p "8080:80@loaadbalancer" -p "8082:443@loadbalancer" -p "8888:8888@loadbalancer"
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
