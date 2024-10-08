## How to use KOPS and create kubernetes cluster?!

People often use tools like **minikube** (tool that allow to create and manage local kubernetes cluster) for learning kubernetes. But it is important to understand, in real work, these tools only used in development environments(to test or something like this). 
In real deployments, DevOps engineers should manage real kubernetes clusters with multiple nodes. For this kubernetes distributions used. 

**Kubernetes distributions**
are customized versions of Kubernetes provided by different vendors to simplify deployment, management, and scaling of Kubernetes clusters. These distributions often include additional tools, integrations, and support to enhance the Kubernetes experience for specific environments, such as on-premises, cloud, or hybrid setups. Here are some of the most popular: OpenShift (Red Hat), Rancher, Amazon EKS (Elastic Kubernetes Service), Azure Kubernetes Service (AKS)

One of the main difference between open source kubernetes distro and for example EKS, is that when you use EKS, you can get a support from amazon in managing EKS cluster, configuration and etc(Because control plane node managed by Amazon). Such distro's has additional plugins and other user experience that it is not present in clear kubernetes distro.

### How DevOps engineers manage their clusters?

One of the most popular tools is **KOPS**. KOPS provide you possibilities to control lifeCycle of your clusters. For example,to install, upgrade, modify, delete your clusters. 
Lets' try to create cluster:

#### 1) Install dependencies:
- Install python3 (it was already installed on EC2 ubuntu)
- Install awscli. From official documentation:
``` bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
- Install kubect. Taken from documentation as well:

```shell
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
```

```shell
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
```

```shell
sudo apt-get update
sudo apt-get install -y kubectl
```
#### 2) Install KOPS
```shell
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops
```

### Install kubernetes cluster

#### 1) Create s3 bucket
Used official documentation https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/create-bucket.html
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240917163640.png)
#### 2) Create Kubernetes cluster with KOPS

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240917171517.png)

```shell
kops create cluster --name testybryk8scluster.k8s.local --state=s3://kops-ybry-test-storage --zones=eu-central-1a --node-count=1 --node-size=t2.micro --control-plane-size=t2.micro --control-plane-volume-size=8 --node-volume-size=8
```

And I applied changes with this command (after that some resources take money):
``` shell
kops update cluster testybryk8scluster.k8s.local --yes --state=s3://kops-ybry-test-storage
```

Now I have my cluster using resources on AWS:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240917173307.png)

With this instruction, I could't validate my cluster. It just can't connect to my cluster, and kubectl didn't work. I tried to troublesjoot, recreate and etc., but it still didn't work. I think maybe the problem in dns I use(k8s.local). So I went to official documentation for KOPS and tried that instruction:
https://kops.sigs.k8s.io/getting_started/aws/

1) ***Created new IAM user KOPS***

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240918205223.png)

2) ***Create  new s3 bucket for storing OIDC documents.***

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240918205338.png)

3) ***And added default encryption to my main s3 bucket***

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240918205526.png)

4) ***Created cluster***

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240918205822.png)

**Now all works as expected**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240918210047.png)


![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240918210349.png)



Then I tried my old command to create cluster, but with this flag. But again, it didn't work
```shell
--discovery-store=s3://prefix-example-com-oidc-store/${NAME}/discovery
```

I also tried to create cluster with this flag, but with t2.micro machines. It still doesn't work.

I tried to create cluster with my old command again, but changed machines type to t3.medium and it works.
So it seems for some reasons I can't create cluster with t2.micro machines. Maybe there are not enough resources.


When two clusters created, to control these clusters, I can change the context of `kubectl`. 
Here I can change my context to 1st cluster.

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240918224322.png)
