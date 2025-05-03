from datetime import timedelta

# needed for any cluster connection
from couchbase.auth import PasswordAuthenticator
from couchbase.cluster import Cluster
# needed for options -- cluster, timeout, SQL++ (N1QL) query, etc.
from couchbase.options import (ClusterOptions, ClusterTimeoutOptions,
                               QueryOptions)


# Update this to your cluster
username = "admin"
password = "T1ku$H1t4m"
bucket_name = "development"
# User Input ends here.

# Connect options - authentication
auth = PasswordAuthenticator(
    username,
    password,
)

# Get a reference to our cluster
# NOTE: For TLS/SSL connection use 'couchbases://<your-ip-address>' instead
cluster = Cluster('couchbase://34.171.199.183', ClusterOptions(auth))

# Wait until the cluster is ready for use.
cluster.wait_until_ready(timedelta(seconds=5))

# get a reference to our bucket
cb = cluster.bucket(bucket_name)

cb_coll = cb.scope("employee").collection("information_employee")

def upsert_document(doc):
    print("\nUpsert CAS: ")
    try:
        # key will equal: "airline_8091"
        key = doc["type"] + "_" + str(doc["id"])
        result = cb_coll.upsert(key, doc)
        print(result.cas)
    except Exception as e:
        print(e)

# get document function


def get_airline_by_key(key):
    print("\nGet Result: ")
    try:
        result = cb_coll.get(key)
        print(result.content_as[str])
    except Exception as e:
        print(e)


def lookup_by_callsign(cs):
    print("\nLookup Result: ")
    try:
        inventory_scope = cb.scope('develipment')
        sql_query = 'SELECT * FROM information_employee '
        row_iter = inventory_scope.query(
            sql_query,
            QueryOptions(positional_parameters=[cs]))
        for row in row_iter:
            print(row)
    except Exception as e:
        print(e)