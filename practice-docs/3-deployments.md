## Kubernetes deployments. Replicasets

To add such features like auto scaling and auto healing for pods, **deployments** yaml files used instead of pods yaml files.
Let's find out what is the difference between containers, pods and deployments

**containers** : we create with container platform(like docker) using CLI interface commands. We describe all settings and specifications there. Like `docker run -it ...`

**pod**: create yaml file where we describe all the specifications for our container. And one single POD can contain several containers. It is not so different from container, therefore deployment exists

**deployment**: it is higher level of abstraction, that contains pods, but additionally we can have such functionality like auto healing, auto scaling for our pods. So, it is a good practice to always create deployments, instead of pods. Specifications of deployments also described in yaml file.


>**Deployment** is a resource in Kubernetes that ensures your application (in the form of pods) is running as desired. It manages the lifecycle of the pods for your application, ensuring:
>- Pods are running and healthy.
>- Pods are distributed across available worker nodes.
>- Updates and rollbacks can be performed smoothly.

A Deployment typically includes:

- **Pods**: The smallest deployable units, which hold your application container(s).
- **ReplicaSets**: Ensure that a specified number of pod replicas are running at any given time. It is one of the kubernetes controllers.
- **Strategy**: Specifies how to roll out updates to your application, either through a rolling update or other strategies.

### Creation of deployment:
1) We create .yaml file where we describe all settings we needed for our pods. And then ReplicaSets and needed amount of pods will be created
2) In deployment .yaml file we specify how many replicas of the pod we need. Based on this info, ReplicaSet ensures that this amount of pods are always running.
3) PODS created. If for example in deployment.yaml file we said we need 10 pods (replicas), and some of them will be killed for some reason, ReplicaSet will notice it and create new pods instead of killed ones. If we want more pods, we can just specify it in yaml file and it will add new pods.


## Practice

Check if we have deployments:
`kubectl get deploy`
And Pods
`kubectl get pods`
And all the info(pods, deployments and cluster info)
`kubectl get all`

And we can see resources for all namespaces:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919150104.png)

>In Kubernetes, **namespaces** are a way to divide cluster resources between multiple users or teams. They provide an organizational mechanism that allows for the logical separation of different parts of the cluster, which helps in managing large and complex environments.

**default namespace**: if you don't specify a namespace when creating resources, they are placed in the `default` namespace.

**kube-system**: The `kube-system` namespace contains the essential system-level components that are required to keep the Kubernetes cluster running. This includes services like DNS, network controllers, and other core infrastructure components.!


When just pods used, I can easily delete it with `kubectl delete pod $POD_NAME` command. But when deployment is used, after removing this pod, the new one will automatically be created.

### Let's create one

**1) I took the simple example of .yaml file from official kubernetes documentation:**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919152234.png)

**2) Create deployment:**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919152338.png)

3) **Let's try to delete one pod**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919153154.png)

4) **Let's increase the amount of pods to 4 in .yaml manfest **

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240919154559.png)

Now it is increased.


---

On the next day I got such error:
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240920160454.png)

!!! Important!
>When KOPS creates cluster, it gives admin access to kubectl for only 18 hours.

To update credentials, I need to execute this command:

```shell
kops export kubecfg --name ybrycluster.k8s.local --admin
```
