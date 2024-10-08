## KUBERNETES INGRESS

To understand what is ingress, let's find out why it is needed.

Before **Kubernetes**, when people used **Virtual Machines** yet, they installed external load balancing tools with many functions they can provide(like different types of load balancing and etc.).
So, when they moved to **containers** and **Kubernetes**, they lost such functions, because at the beginning **Kubernetes** didn't support any additional load balancing, only load balancing with **Service**.
It means, before there was no such thing like **ingress** in **Kubernetes**.
 
### So, there were 2 problems:
1)  No Enterprise and secure level of Load balancing with **Kubernetes**.
2) You had to create every service with LoadBalancer type. It is very expensive.

**Kubernetes** developers came up with a new function, so now you can create a new resource in your cluster, called **ingress**. 

### What is this "Ingress" for?
This resource allow all to create their own load balancers, called **Ingress controllers** and add it to cluster: 
1) For example Netflix creates own **Ingress Controller**.
2) They deploy it to **Kubernetes** cluster.
3) They create **Ingress resource** in cluster where they describe all configuration they want (in .yaml file). With this resource they expose traffic to external traffic. (without Ingress controller it doesn't work!)

It can be many types of Ingress Controllers, and Ingress whose can provide different load balancing. 

# Practice:

I already have a peloyment with simple python app and service(changed it to ClusterIp type):

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001191011.png)


### Let's add simple host based ingress.

**1) Install Nginx ingress controller. For this I should install **helm**.(use off documentation)**
   
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001192725.png)

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001193221.png)

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001193303.png)

Now we can see that nginx controller POD and Service added

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001193429.png)

Then I tried to create ingress resource, but nothing worked. I tried different types of ingress resources and etc.

I have ingress like this: 
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001214405.png)
I have no ADDRESS, and can't connect to my service.

So I thought ADDRESS should always be filled, so tried to make it filled. But nothing helped. 

I tried another ingress controller, traefik 

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001214637.png)

**2) And I created new Ingress resource:**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001215109.png)

Again it doesn't have ADDRESS, so I thought nothing helped and it didn't sync again

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001215156.png)

But I tried to connect with this host address, and now my Django app accessible externally.

So it works, ADDRESS shouldn't be filled to have ingress synced, I was wrong.

**So, now i have my service with ClusterIp type, and it is still accessible from external world because of Ingress controller and Ingress resource I created.**
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241001215555.png)


>I tested with nginx controller again, it doesn't work with it at all. I don't know why (**fixed it later**). But all works with TRAEFIC, host based and not host based. All is fiine
