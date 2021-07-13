#!/bin/bash 

curr_dir=${PWD}
src_dir="sns"
destination="mochi/${src_dir}"

cd "$src_dir"
old_state_file="../${src_dir}_old.tfstate"
terraform state pull > "$old_state_file"
echo "Pulled old state file: $old_state_file ....... "


cd "${curr_dir}/$destination"
new_state_file="${curr_dir}/${src_dir}_new.tfstate"
terragrunt init
terraform state pull > "$new_state_file"
echo "Pulled new state file: $new_state_file ....... "


cd ${PWD}
