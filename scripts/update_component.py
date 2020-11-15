import json
import os

component = os.environ.get("APP_COMPONENT")
version = os.environ.get("APP_VERSION")

versions_file_path = "./terraform/app-version.auto.tfvars.json"


if not component or not version:
    print("COMPONENT or VERSION env vars are empty")
    exit(1)


print("Opening manifest file: %s" % versions_file_path)
with open(versions_file_path, 'r') as versions_file:
    versions = json.loads(versions_file.read())


print("Updating %s" % component)
versions["components_versions"][component] = version


print("Saving components versions to file!")
with open(versions_file_path, "w") as versions_file:
    versions_file.write(json.dumps(versions, indent=2))
