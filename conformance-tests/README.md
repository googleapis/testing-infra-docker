# Conformance Test Images

## Storage

### Retry

Build a docker image of the [GCS Storage Retry Conformance Test Server](https://github.com/googleapis/google-cloud-cpp/tree/master/google/cloud/storage/emulator).

Images are tagged using the following pattern:
```
gcr.io/cloud-devrel-kokoro-resources/conformance-tests/storage/retry:${SHORT_SHA}_server-${CPP_SHORT_SHA}
```

Where `CPP_SHORT_SHA` is defined as the 10 character substring of the SHA of `HEAD`
of the default branch of https://github.com/googleapis/google-cloud-cpp

## Building

```bash
gcloud --project=cloud-devrel-kokoro-resources builds submit --config=cloudbuild.yaml
```
