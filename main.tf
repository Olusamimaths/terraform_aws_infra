
resource "aws_s3_bucket" "state-bucket" {
  bucket        = "state-bucket-22092048"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.state-bucket.id
  acl    = "private"
  depends_on = [ aws_s3_bucket_ownership_controls.this ]
}
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.state-bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }  
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.state-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "state-bucket-lock" {
  name           = "state-bucket-lock-22092048"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 10

  attribute {
    name = "LockID"
    type = "S"
  }
}

module "network" {
  source = "./modules/network"
  namespace = var.namespace
  project_name = var.project_name
}

module "database" {
  source = "./modules/database"
  namespace = var.namespace
  project_name = var.project_name
  vpc = module.network.vpc
  subnet = module.network.subnet
  app_security_group = module.instance.security_group
}

module "instance" {
  source = "./modules/instance"
  namespace = var.namespace
  project_name = var.project_name
  vpc = module.network.vpc
  ssh_key = var.ssh_key
  alb = module.network.alb
  subnet = module.network.subnet
  db_config = module.database.db_config
}