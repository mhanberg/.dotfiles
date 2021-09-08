vim.g.dbs = {
  dev = "postgres://postgres:postgres@localhost:5432/orders_service_dev",
  staging = "postgres://postgres:postgres@localhost:5433/orders_service_dev",
  staging_fas = "postgres://postgres:postgres@localhost:5433/facility_activity_service_dev",
}

vim.g.db_ui_auto_execute_table_helpers = 1
