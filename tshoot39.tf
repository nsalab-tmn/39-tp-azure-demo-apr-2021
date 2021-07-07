module "competition" {
    source = "./terraform"
    count = 31
    prefix = format("comp-%02d", count.index+1)
}

# module "competition-west" {
#     source = "./terraform-westus"
#     count = 10
#     prefix = format("comp-%02d", count.index+11)
# }

# module "competition-south" {
#     source = "./terraform-southcentralus"
#     count = 10
#     prefix = format("comp-%02d", count.index+21)
# }


output "passwords" {
  value = [ module.competition.*.pass ]
}

# output "passwords-west" {
#   value = [ module.competition-west.*.pass ]
# }


# output "passwords-south" {
#   value = [ module.competition-south.*.pass ]
# }