
resource "aws_glue_catalog_database" "sales_database" {
  name = "sales"
}

resource "aws_glue_classifier" "aws_glue_csv_classifier" {
  name = "csv-classifier"

  csv_classifier {
    header = ["PRODUCT_NAME", "COUNTRY", "PRICE", "QUANTITY"]
    contains_header = "ABSENT"
    quote_symbol = "\""
    delimiter = ","
  }
}

resource "aws_glue_crawler" "aws_glue_custom_csv_crawler" {
  name = "custom-csv-crawler"
  database_name = aws_glue_catalog_database.sales_database.name
  classifiers = [aws_glue_classifier.aws_glue_csv_classifier.id]
  role = aws_iam_role.aws_iam_glue_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.bucket_for_glue.bucket}/sales/"
  }
}

//resource "aws_glue_job" "aws_glue_job_nginx_logs_processing" {
//  name = "aws-glue-job-nginx-logs-processing"
//  role_arn = aws_iam_role.aws_iam_glue_role.arn
//
//  command {
//    name = "glue_etl_process_nginx_logs"
//
//    script_location = "s3://${aws_s3_bucket.bucket_for_glue.bucket}/scripts/process_nginx_logs.py"
//    python_version = "3"
//  }
//
//  default_arguments = {
//
//    "--continuous-log-logGroup" = aws_cloudwatch_log_group.aws_glue_nginx_log_group.name
//    "--enable-continuous-cloudwatch-log" = "true"
//    "--enable-continuous-log-filter" = "true"
//    "--enable-metrics" = ""
//  }
//}
