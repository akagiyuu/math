use axum::{extract::Query, routing::get, Router};
use std::collections::HashMap;
use core::eval;

async fn query(Query(params): Query<HashMap<String, String>>) -> String {
    let expression: &str = params.get("expr").unwrap();
    let format: &str = params.get("format").unwrap();
    eval(expression.to_string(), format.parse().unwrap())
}

const ADDRESS: &str = "0.0.0.0:3030";

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(query))
        .route("/help", get(|| async { "https://reference.wolfram.com" }));

    axum::Server::bind(&ADDRESS.parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}
