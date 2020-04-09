# Udactiy Cloud DevOps ND - Project-2 - HA web app using CloudFormation

### Creating the stack 

`./create-stack.sh **stack_name** **template_file** **parameters_file** **region**`

e.g.

`./create-stack.sh udacitystack CloudFormationInfrastructure.yml infrastructure-parameters.json us-west-2`

**N.B.** AMIs are Ubuntu 18.04 LTS

### SSH Forwarding

To enable ssh agent forwarding you need to add your SSH private key to Keychain so it's automatically available
to ssh.

#### Step 1 - Store the key in the Keychain
`ssh-add -K [your-private-key]`

#### Step 2 - Configure SSH to always use the keychain
In `.ssh/config` file, add the following lines:
```Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa
```

The `UseKeychain yes` is the *key* part, which tells SSH to look in your keychain for the key passphrase.

#### SSH into your Instance
`ssh -A <user>@<bastionhost>`