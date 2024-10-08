## CONFIGMAPS and SECRETS. Hot to use it?


>**ConfigMap** in Kubernetes is an API object that stores non-sensitive configuration data in key-value pairs. It allows you to decouple configuration settings from container images, enabling changes to the configuration without needing to rebuild container images. ConfigMaps can be used to pass environment variables, command-line arguments, or configuration files to containers, ensuring flexibility and scalability in managing application settings. Unlike Secrets, ConfigMaps are not meant for sensitive information like passwords or API tokens.


Let's understand why do we need it.
Applications often need to know some config information to access databases(know the port, user and password variables), to use other applications with certain configs and etc. These configs usually stored as environment variables or written in files. But what if these values changes pretty often? We should update these value as well inside the applications, VMs or containers(they are usually not hard coded) . But while for VM it is easy to just change config values inside the machine, with containers it’s not that straightforward because containers are designed to be immutable once built.
If the configuration inside a container changes, you would typically have to rebuild and redeploy the container, which is time-consuming and inefficient.

This is where **ConfigMaps** come in. We can create **ConfigMap** inside the cluster, fill it with all needed config values and mount it to needed pod.
After that these values can be used by application.

The same can be achieved with **Secrets**, but the only difference is that values in secrets will be encrypted. This is used for sensitive info like tokens, passwords and etc.


## PRACTICE

I have two ways to add config values to my containers:

### 1st way, create config map and use the value in deployment .yaml

**1) Create **ConfigMap** and apply.**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006053735.png)

We can check that inside our pod no db-port value yet:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006054247.png)

**2) We need to modify our deployment `.yaml` to add there a value from **ConfigMap** and apply it.**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006055051.png)

Now we see that PODS has new env value **DB_PORT**: 
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006055127.png)

>This way is not so good as the value in ConfigMap can often be changed. And every time we need to reapply deployment and this leads to recreation of the containers. It is not very good. So the 2nd way solves this problem.

### 2nd way, mount volume file with value

**1) Create Volume and mount it to container.**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006061521.png)

Now we can see that file with variable added:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006061658.png)

**2) Now let's change the value to 3309**

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006062022.png)

And it is updated in the pod without recreating it: 

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006062103.png)


## Secrets

**Secrets created and used the same way**. We can create secret using .yaml and apply it. 

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006065503.png)

The only difference that the value will be encrypted. When we will try to check it with `kubectl describe secret secret-name` we this:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006063959.png)

And the output when edit secret: `kubectl edit secret secret-name`. Encoded on base64

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006064548.png)

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241006065331.png)
