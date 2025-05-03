from couchbase.cluster import Cluster
from couchbase.options import ClusterOptions, QueryOptions
from couchbase.auth import PasswordAuthenticator
from couchbase.exceptions import CouchbaseException

cluster = Cluster.connect(
    "couchbase://34.171.199.183",
    ClusterOptions(PasswordAuthenticator("admin", "T1ku$H1t4m")))
bucket = cluster.bucket("development")
collection = bucket.default_collection()

try:
    result = cluster.query(
        "SELECT * FROM development.employee.information_employee LIMIT 10", QueryOptions(metrics=True))

    for row in result.rows():
        print(f"Found row: {row}")

    print(f"Report execution time: {result.metadata().metrics().execution_time()}")

except CouchbaseException as ex:
    import traceback
    traceback.print_exc()