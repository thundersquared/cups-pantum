# CUPS with Pantum drivers

This is a pretty chill Docker image that builds the latest version of CUPS and bundles the following Pantum driver:

- Pantum Ubuntu Driver V1.1.123

## Quick Start

1. Pull the image:
```bash
docker pull ghcr.io/thundersquared/cups-pantum:latest
```

2. Run the container:
```bash
docker run -d \
  --name cups \
  -p 631:631 \
  -v cups-config:/etc/cups \
  -v cups-logs:/var/log/cups \
  -v cups-spool:/var/spool/cups \
  -v cups-cache:/var/cache/cups \
  ghcr.io/thundersquared/cups-pantum:latest
```

## Configuration

The CUPS web interface is available at http://localhost:631.

## Volumes

- `/etc/cups`: CUPS configuration files
- `/var/log/cups`: CUPS log files
- `/var/spool/cups`: Print spooling directory
- `/var/cache/cups`: CUPS cache directory

## Environment Variables

None required for basic operation.

## Security

The container runs CUPS with default security settings. For production use, consider:

- Using a non-root user
- Configuring CUPS access controls
- Setting up SSL/TLS

## Contributing

Pull requests are welcome. For major changes, please open an issue first.

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
