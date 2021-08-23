module "competition" {
    source = "./terraform"
    count = 14
    prefix = format("comp-%02d", count.index+1)
    competition_instance = "demo39"
}

output "passwords" {
  value =  module.competition.*.pass 
}

output "static-params" {
  value =  module.competition[0].static-params 
}

output "dynamic-params" {
  value = merge(module.competition.*.dynamic-params...)
}