## What is PODS and hot to create them? 

In docker we create container with a simple command, docker run. But in kubernetes PODS are used, and to create these PODS `yaml` files used. There we describe all the settings for our pod (what containers, specifications of it and etc.)

Usually POD is one container, but sometimes it can be several containers(we put several containers to POT to allow them use shared network, shared storage and etc). But as I said, more popular is to have 1 container for 1 POD.

### Let's create a simple pod using my previously created cluster:

I created simple-pod.yaml file from official kubernetes documentation:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919011255.png)

We can compare it with docker command. Analogue command will be : `docker run -d nginx:1.14.2 --name nginx -p 80:80 `

And create pod:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919011646.png)

Later in the video he shows how to check if nginx pod works fine, so need to login to master node with ssh. It seems I had no key for my nodes, so I wasn;t able to do it. I regenerated the key and added to nodes.

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919014150.png)


**And it works**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919015126.png)

Useful page: kubectl cheat sheet:
https://k8s-docs.netlify.app/en/docs/reference/kubectl/cheatsheet/

Useful command to troubleshoot pods:
```
kubectl describe pod $POD_NAME
kubectl logs $POD_NAME
```
Also we can change settings of the POD in that yaml file.

To add such features like auto scaling and auto healing for pods, **deployments** yaml files used. We discuss it in the next note.
