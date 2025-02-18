### Min 53:00

### Install-Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

### Install-Docker


### Install-Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
kubectl version --client --output=yaml
### Install-Kubectl


### Install-Kind
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
### Install-Kind

###  Create Cluster and Nodes
git clone https://github.com/initcron/k8s-code.git
cd k8s-code/helper/kind/
kind create cluster --config kind-three-node-cluster.yaml


# Install Kube Ops View
git clone  https://github.com/schoolofdevops/kube-ops-view
kubectl apply -f kube-ops-view/deploy/



### kubectl commands

## Namespaces
kubectl get ns
kubectl create namespace instavote
kubectl get ns

## Contexts
kubectl config --help
kubectl config get-contexts
kubectl config current-context
kubectl config set-context --help
kubectl config set-context --current --namespace=instavote
kubectl config get-contexts
kubectl config view

kubectl config set-context --current --namespace=default
kubectl config set-context --current --namespace=kube-system
kubectl config set-context --current --namespace=instavote


## ReplicaSet
cd k8s-code/projects/instavote/dev/
kubectl apply -f vote-rs.yaml

# selector: Scalability
kubectl scale rs vote --replicas=4
kubectl get pods --show-labels

# replicas: HA
kubectl get pods
kubectl delete pods vote-xxxx vote-yyyy



## Service: Load balances of pods
kubectl apply -f vote-svc.yaml --dry-run=client
kubectl apply -f vote-svc.yaml
kubectl get svc
kubectl describe service vote

# Explore iptables
docker exec -it --privileged kind-worker2 sh
iptables -nvL -t nat  
iptables -nvL -t nat  | grep 30000
iptables -nvL -t nat  | grep KBRHWPABPD6YOBY7  -A 3


## Expose External IPS
# Add externalIPs:
#   - xx.xx.xx.xx
#   - yy.yy.yy.yy
kubectl  get svc
kubectl apply -f vote-svc.yaml
kubectl  get svc
kubectl describe svc vote

## Apply redis
