# Troubleshooting

### `No such network:`

  ERROR: for redis  No such network: wwwcenturionde_default
  ERROR: Encountered errors while bringing up the project.

- check your networks with `docker network ls`
- remove duplicate ones by ID
- `docker-compose down`
- `docker-compose up`
