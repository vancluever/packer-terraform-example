# Packer and Terraform Pattern Example

This repository houses a simple application that demonstrates an end-to-end
infrastructure as code pattern using Packer and Terraform.

This repository serves as the technical example for the following article:
https://vancluevertech.com/2016/02/02/aws-world-detour-packer-and-terraform/

## The Components

 * A small ruby gem (`vancluever_hello`). This is built using rubygems tasks
   using `rake`.
 * A Chef recipe designed for deploying the application (`packer_payload`).
   This is a single-purpose cookbook that is not intended to be shared in
   Supermarket, etc. It's only intended for use with Packer. With that said,
   having a cookbook allows you to port this functionality to a general-use
   cookbook if necessary - this can then be included from a fresh
   `packer_payload` cookbook.
 * A packer template located at `packer/ami.json`
 * Terraform infrastructure in the `terraform` directory, comprised of a single
   template for now, `main.tf`.

You manage all of this with `rake`.

## The `Rakefile`

The `Rakefile` has tasks for managing the full lifecycle from building of the
gem, to AMI, to deployment. The list is below:

```
rake ami              # Create an application AMI with Packer
rake berks_cookbooks  # Vendors dependent cookbooks in berks-cookbooks (for Packer)
rake build            # Build vancluever_hello-0.1.0.gem into the pkg directory
rake clean            # Remove any temporary products
rake clobber          # Remove any generated files
rake infrastructure   # Deploy infrastructure using Terraform
```

In addition to that, the file also has helper functions for looking up
AMI IDs to be used in the build process.

## Using this Repository

To prepare the repository for use, clone it and run

```
bundle install --binstubs --path vendor/bundle
```

You should then be good to start using `bundle exec rake`. Get a list of
commands by running `bundle exec rake -T`.

You also need [Packer](https://www.packer.io/) and
[Terraform](https://www.terraform.io/).

Finally, valid AWS credentials will need to be available in your credential
chain, either as environment variables (ie: `AWS_ACCESS_KEY`,
`AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN`), or your credentials in your
`~/.aws` directory.

### Environment variables

You can also control the build process through the following environment
variables:

 * `DISTRO` To control the Ubuntu distribution to use (default `trusty`).
 * `REGION` To control the region to deploy to (default `us-east-1`).
 * `TF_CMD` To control the Terrafrom command (default `apply`).

## Author and License

```
Copyright 2016 Chris Marchesi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
