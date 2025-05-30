{
  pkgs,
  age-secrets,
  ...
}:
with pkgs;
  writeShellApplication {
    name = "export-aws-vars";
    runtimeInputs = [awscli2];
    text = ''
      main() {
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_SESSION_TOKEN
        cmd="AWS_PROFILE=dag-default aws sts assume-role $(cat "${age-secrets.secrets.export-aws-keys.path}")"
        creds="$(eval "$cmd")"

        access_key_id=$(echo "$creds" | jq -r .Credentials.AccessKeyId)
        secret_access_key=$(echo "$creds" | jq -r .Credentials.SecretAccessKey)
        session_token=$(echo "$creds" | jq -r .Credentials.SessionToken)

        echo "
      export AWS_ACCESS_KEY_ID='$access_key_id'
      export AWS_SECRET_ACCESS_KEY='$secret_access_key'
      export AWS_SESSION_TOKEN='$session_token'
      "
      }

      main "$@"
    '';
  }
