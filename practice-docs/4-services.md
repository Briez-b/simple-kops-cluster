## Kubernetes services

Let's deploy our application and create a service for it. I will use simple python app that we created in one of previous videos:
**1) Build docker image:**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927151357.png)

**2) Write deployment manifest and apply:**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927152341.png)

`kubectl apply -f django-app-deploy.yaml`
Now I have a deployment with 2 pods running.
Without service, I can only access my django app inside a cluster

> **Additional note:**
> I checked how can I access my application without service. (For example to test if all is fine) I can use:
> ![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927154717.png)
> Or I can execute a command inside the pod using `kubectl`(in such case I need curl installed inside the pod):
> ![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927154915.png)

**3) Write service .yaml file with  NodePort mode**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927160445.png)

**4) And apply it**:

`kubectl apply -f django-app-service.yaml`
Show all services in cluster:
`kubectl get svc`

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927161518.png)

Now I am able to access my app using node's external IP. I only needed add inbound rule for this port:
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927162940.png)

Now app accessible with http://18.156.84.80:30007/demo/ 

**We can change the mode type of service**. We can edit the service config with `kubectl edit svc $SERVICE_NAME`(just find the string with NodePort and edit to LoadBalancer):

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927174352.png)

Now my application can be accessed with this address:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020240927174442.png)


To see what is happening in my cluster(see the actors and events that they send to pods, something like wireshark), I can use **kubeshark**. But for some reason it doesn't work with my cluster.
I checked later. Now everything is fine. Maybe preciously I had a too small worker node. Now I have a cluster with t3.medium master and worker.

Now with kubeshark I can see that requests go to different pods(load balancing happens).


![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001165341.png)
