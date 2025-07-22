# Contributing to Unix/Linux Audit Utility

Thank you for your interest in contributing to the Unix/Linux Audit Utility! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Guidelines](#development-guidelines)
- [Security Considerations](#security-considerations)
- [Testing](#testing)
- [Documentation](#documentation)
- [Submitting Changes](#submitting-changes)
- [Review Process](#review-process)

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior through the project's issue tracker.

## Getting Started

### Prerequisites

- Basic knowledge of shell scripting (bash/sh)
- Understanding of Unix/Linux system administration
- Familiarity with security auditing concepts
- Access to test systems for validation

### Development Environment

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/Linux-Audit-Utility.git
   cd Linux-Audit-Utility
   ```

2. **Set Up Test Environment**
   - Use virtual machines or containers
   - Test on multiple OS versions
   - Ensure isolated testing environment

3. **Review Existing Scripts**
   - Understand current script structure
   - Review coding patterns and conventions
   - Check output formats and file structures

## How to Contribute

### Types of Contributions

- **Bug Fixes**: Fix issues in existing scripts
- **Feature Enhancements**: Add new data collection capabilities
- **New OS Support**: Add support for additional Unix/Linux variants
- **Documentation**: Improve documentation and examples
- **Security Improvements**: Enhance security features
- **Performance Optimizations**: Improve script efficiency

### Contribution Workflow

1. **Check Existing Issues**
   - Look for existing issues or feature requests
   - Comment on issues you'd like to work on
   - Create new issues for bugs or feature requests

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Follow coding guidelines
   - Test thoroughly
   - Update documentation

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add new system information collection"
   ```

5. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```

## Development Guidelines

### Coding Standards

#### Shell Script Best Practices

1. **Shebang Line**
   ```bash
   #!/bin/bash
   # or
   #!/bin/sh
   ```

2. **Error Handling**
   ```bash
   set -e  # Exit on error
   set -u  # Exit on undefined variable
   ```

3. **Function Structure**
   ```bash
   function_name() {
       local var_name="$1"
       # Function logic here
       return 0
   }
   ```

4. **Variable Naming**
   - Use lowercase with underscores: `file_name`
   - Use descriptive names: `output_directory`
   - Quote variables: `"$variable_name"`

5. **Comments**
   ```bash
   # Single line comment
   
   #######################################
   # Multi-line comment block
   # Description of complex logic
   #######################################
   ```

#### Script Structure

Maintain consistent structure across all scripts:

```bash
#!/bin/bash

#######################################
# Script Header with USER GUIDE
#######################################

# Color definitions
# Global variables
# Function definitions
# Main execution logic
```

### Naming Conventions

- **Scripts**: `OS_Type.sh` (e.g., `Ubuntu_Linux.sh`)
- **Functions**: `collect_system_info()`
- **Variables**: `output_folder`, `current_date`
- **Files**: Use descriptive names matching content

### Output Standards

1. **Folder Naming**
   ```
   ${hostname}[${ip_address}]${datetime}_${OS_TYPE}
   ```

2. **File Naming**
   - Use descriptive names: `network_configuration.txt`
   - Maintain consistency across scripts
   - Include file extensions

3. **Content Format**
   - Include headers and separators
   - Add timestamps where relevant
   - Use consistent formatting

## Security Considerations

### Security Requirements

1. **Data Protection**
   - Never log sensitive data in plain text
   - Implement proper error handling
   - Use secure temporary file creation

2. **Privilege Management**
   - Check for required privileges
   - Gracefully handle permission denials
   - Document privilege requirements

3. **Input Validation**
   - Validate all user inputs
   - Sanitize file paths
   - Check command availability

4. **Timeout Protection**
   ```bash
   timeout 10s command_name || echo "Command timed out"
   ```

### Security Review Checklist

- [ ] No hardcoded credentials or sensitive data
- [ ] Proper error handling for all operations
- [ ] Timeout protection for potentially hanging commands
- [ ] Input validation and sanitization
- [ ] Secure file creation and permissions
- [ ] Documentation of security implications

## Testing

### Testing Requirements

1. **Functional Testing**
   - Test on target operating systems
   - Verify all data collection functions
   - Check error handling scenarios

2. **Security Testing**
   - Test with different privilege levels
   - Verify timeout mechanisms
   - Check for information disclosure

3. **Performance Testing**
   - Monitor execution time
   - Check resource usage
   - Test on systems with limited resources

### Testing Checklist

- [ ] Script executes without errors
- [ ] All expected files are created
- [ ] Output format is consistent
- [ ] Error handling works correctly
- [ ] Timeouts function properly
- [ ] No sensitive data exposure
- [ ] Performance is acceptable

### Test Environments

Test on multiple environments:

- **Linux Distributions**
  - RHEL/CentOS/Oracle Linux
  - SUSE Linux Enterprise
  - Ubuntu/Debian
  - Alpine Linux

- **Unix Systems**
  - IBM AIX
  - Solaris (if adding support)
  - FreeBSD (if adding support)

## Documentation

### Documentation Requirements

1. **Code Comments**
   - Document complex logic
   - Explain security considerations
   - Include usage examples

2. **README Updates**
   - Update feature lists
   - Add new OS support information
   - Include new prerequisites

3. **User Guide Updates**
   - Update script headers
   - Document new features
   - Include troubleshooting information

### Documentation Standards

- Use clear, concise language
- Include practical examples
- Document security implications
- Maintain consistency across documents

## Submitting Changes

### Pull Request Guidelines

1. **PR Title Format**
   ```
   type(scope): brief description
   
   Examples:
   feat(aix): add disk usage collection
   fix(oracle): resolve timeout issue in network scan
   docs(readme): update installation instructions
   ```

2. **PR Description Template**
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Security improvement
   
   ## Testing
   - [ ] Tested on target OS
   - [ ] All tests pass
   - [ ] No security issues
   
   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Self-review completed
   - [ ] Documentation updated
   - [ ] Security review completed
   ```

3. **Commit Message Format**
   ```
   type(scope): description
   
   Types: feat, fix, docs, style, refactor, test, chore
   Scope: aix, oracle, suse, docs, security
   ```

### Before Submitting

- [ ] Code follows project guidelines
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] Security review completed
- [ ] No merge conflicts
- [ ] PR description is complete

## Review Process

### Review Criteria

1. **Code Quality**
   - Follows coding standards
   - Proper error handling
   - Clear and maintainable code

2. **Security**
   - No security vulnerabilities
   - Proper data handling
   - Appropriate privilege usage

3. **Functionality**
   - Features work as intended
   - No breaking changes
   - Backward compatibility maintained

4. **Documentation**
   - Code is well-documented
   - User documentation updated
   - Security implications documented

### Review Timeline

- **Initial Review**: Within 48 hours
- **Detailed Review**: Within 1 week
- **Security Review**: Within 1 week for security-related changes
- **Final Approval**: After all requirements met

## Getting Help

### Resources

- **Issues**: Use GitHub issues for bugs and feature requests
- **Discussions**: Use GitHub discussions for questions
- **Security**: Follow [Security Policy](SECURITY.md) for security issues

### Contact

- Create an issue for technical questions
- Use discussions for general questions
- Follow security policy for security concerns

## Recognition

Contributors will be recognized in:

- Release notes
- Contributors section
- Security acknowledgments (for security contributions)

---

**Thank you for contributing to the Unix/Linux Audit Utility!**

Your contributions help improve security assessment capabilities for the entire community. Please don't hesitate to ask questions or seek clarification on any aspect of the contribution process.