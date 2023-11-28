#!/bin/bash

touch ~/.bashrc
terraform -install-autocomplete

exec $@