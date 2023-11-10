pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name '.ropeproject' -exec rm -rf "{}" \;
}

get_secret_from_secrets_manager() {
    aws secretsmanager get-secret-value --secret-id "$1" | jq .SecretString | jq fromjson
}
