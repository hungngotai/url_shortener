# Content:
  1. [Requirements](#requirements)
  2. [Approach](#approach)
  3. [Issues](#issues)
  4. [References](#4-references)
  5. [How-to](https://github.com/hungngotai/url_shortener/blob/master/how-to.md)
  6. [Api document](https://github.com/hungngotai/url_shortener/blob/master/swagger/v1/swagger.yaml)

## **1. Requirements:**
  1. Language: Ruby
  2. /encode: Encodes a URL to a shortened URL
  3. /decode: Decodes a shortened URL to its original URL

## **2. Approach:**
  Assume we generate the short URL using base62, then:

  - The short URL should be unique so firstly check the existence of this short URL in DB. If it’s already present there for some other long URL then generate a new short URL.
  - If the short URL isn’t present in DB then put the long URL and short URL in DB.

  This approach works with one server very well but if there will be multiple servers then this technique will create a race condition. When multiple servers will work together, there will be a possibility that they all can generate the same unique id or same short URL for different long URLs, and even after checking DB, they will be allowed to insert the same tiny URLs simultaneously (which is the same for different long URLs) in DB and this may end up corrupting the data.

  Next:

  - Encode the long URL using the MD5 approach and take only the first 7 chars to generate TinyURL.
  - The first 7 characters could be the same for different long URLs so check the DB (as we have discussed in technique 1) to verify that TinyURL is not used already
  - **Advantages**: This approach saves some space in DB but how? If two users want to generate a short URL for the same long URL then the first technique will generate two random numbers and it requires two rows in DB but in the second technique, both the longer URL will have the same MD5 so it will have the same first 43 bits which means we will get some deduping and we will end up with saving some space since we only need to store one row instead of two rows in DB.

  MD5 saves some space in DB for the same URLs but for two long different URLs again we will face the same problem as we have discussed.

## **Counter Approach - We choose it:**

Using a counter is a good decision for a scalable solution because counters always get incremented so we can get a new value for every new request.

### Single server approach:

- A single host or server (say database) will be responsible for maintaining the counter.
- When the worker host receives a request it talks to the counter host, which returns a unique number and increments the counter. When the next request comes the counter host again returns the unique number and this goes on.
- Every worker host gets a unique number which is used to generate TinyURL.

**Problem**: If the counter host goes down for some time then it will create a problem, also if the number of requests will be high then the counter host might not be able to handle the load. So challenges are a Single point of failure and a single point of bottleneck.
And what if there are multiple servers?

We can’t maintain a single counter and returns the output to all the servers. To solve this problem we can use multiple internal counters for multiple servers which use different counter ranges. For example server 1 ranges from 1 to 1M, server 2 ranges from 1M to 10M, and so on. But again we will face a problem i.e. if one of the counters goes down then for another server it will be difficult to get the range of the failure counter and maintain it again. Also if one counter reaches its maximum limit then resetting the counter will be difficult because there is no single host available for coordination among all these multiple servers. The architecture will be messed up since we don’t know which server is the master or which one is a slave and which one is responsible for coordination and synchronization.

**Further Solution**: To solve this problem we can use a distributed service Zookeeper to manage all these tedious tasks and to solve the various challenges of a distributed system like a race condition, deadlock, or particle failure of data. Zookeeper is basically a distributed coordination service that manages a large set of hosts. It keeps track of all the things such as the naming of the servers, active servers, dead servers, and configuration information of all the hosts. It provides coordination and maintains the synchronization between the multiple servers.

## **3. Issues**:
  - Build the lightweight version of this application only by Ruby. Rails is good but it's also too large. We can use builtin SecureRandom class for generating the short URL. But I try to complete the main task from scratch.
  - When we do without Rails, we must handle the DDoS Attack.

## **4. References:**
  - https://www.geeksforgeeks.org/system-design-url-shortening-service/
  - https://medium.com/double-pointer/system-design-interview-url-shortener-c45819b252cd
