# Security Policy

## Supported Versions

We actively support the latest version of the Linux Audit Utility scripts. Security updates will be provided for:

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < Latest| :x:                |

## Reporting a Vulnerability

### Security Contact

If you discover a security vulnerability in the Linux Audit Utility, please report it responsibly:

- **Email**: [Create an issue with "SECURITY" label]
- **Response Time**: We aim to acknowledge security reports within 48 hours
- **Resolution Time**: Critical vulnerabilities will be addressed within 7 days

### What to Include

When reporting a security vulnerability, please include:

1. **Description**: Clear description of the vulnerability
2. **Impact**: Potential impact and affected systems
3. **Reproduction**: Step-by-step instructions to reproduce
4. **Environment**: Operating system and version details
5. **Proof of Concept**: If applicable, include PoC code

### Security Considerations for Users

#### Before Running Scripts

- **Authorization**: Ensure you have explicit permission to run audit scripts
- **Environment**: Test in non-production environments first
- **Privileges**: Run with minimum required privileges
- **Network**: Consider network impact of data collection

#### Data Protection

- **Sensitive Data**: Scripts may collect sensitive system information
- **Storage**: Secure storage of output files is user responsibility
- **Transmission**: Use secure channels for transferring audit data
- **Retention**: Follow data retention policies for collected information
- **Access Control**: Implement proper access controls on audit outputs

#### Script Security

- **Verification**: Verify script integrity before execution
- **Review**: Review scripts before running in your environment
- **Monitoring**: Monitor script execution for unexpected behavior
- **Logging**: Maintain audit logs of script execution

### Known Security Considerations

#### Information Disclosure

- Scripts collect detailed system configuration information
- Output files may contain sensitive data including:
  - User account information
  - Network configuration
  - Running processes and services
  - System vulnerabilities (patch levels)
  - File permissions and ownership

#### Privilege Requirements

- Some data collection requires elevated privileges
- Scripts include timeout protections to prevent hanging
- Error handling prevents script crashes from sensitive operations

#### Network Impact

- Scripts perform network connectivity tests
- DNS lookups and ping operations may be logged by network monitoring
- Consider firewall and network security policies

### Security Best Practices

1. **Principle of Least Privilege**: Run scripts with minimum required permissions
2. **Secure Storage**: Encrypt audit output files at rest
3. **Secure Transmission**: Use encrypted channels for data transfer
4. **Regular Updates**: Keep scripts updated to latest version
5. **Environment Isolation**: Use dedicated systems for security auditing
6. **Access Logging**: Log all access to audit scripts and outputs
7. **Data Classification**: Classify audit data according to sensitivity
8. **Incident Response**: Have procedures for handling security incidents

### Responsible Disclosure

We follow responsible disclosure practices:

1. **Acknowledgment**: Security reporters will be acknowledged
2. **Coordination**: We coordinate with reporters on disclosure timeline
3. **Credit**: Security researchers receive appropriate credit
4. **Updates**: Security fixes are released promptly
5. **Communication**: Clear communication throughout the process

### Security Updates

Security updates will be:

- Released as soon as possible after verification
- Clearly marked in release notes
- Communicated through repository notifications
- Documented with CVE numbers when applicable

---

**Note**: This security policy applies to the Linux Audit Utility scripts themselves. Users are responsible for the security of systems where scripts are executed and the protection of collected audit data.