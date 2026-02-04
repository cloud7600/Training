# Contributing to Azure Bicep IaC Training

Thank you for your interest in contributing to this project! This document provides guidelines for contributing.

## How to Contribute

### Reporting Issues

- Use the GitHub issue tracker to report bugs or suggest features
- Clearly describe the issue including steps to reproduce
- Include Bicep version and Azure CLI version information

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
   - Follow the existing code style
   - Add or update documentation as needed
   - Ensure all Bicep templates build successfully
4. **Test your changes**
   - Validate templates: `az bicep build --file your-template.bicep`
   - Lint templates: `az bicep lint --file your-template.bicep`
5. **Commit your changes**
   ```bash
   git commit -m "Add meaningful commit message"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Submit a pull request**

## Bicep Template Guidelines

### Module Structure

- Keep modules focused on a single resource type
- Use clear, descriptive parameter names
- Add `@description` annotations to all parameters
- Include appropriate output values
- Use `@allowed` for restricted parameter values

### Naming Conventions

- Use camelCase for parameters and variables
- Use descriptive names that indicate purpose
- Prefix related parameters (e.g., `storageAccountName`, `storageAccountSku`)

### Security Best Practices

- Never hardcode secrets or sensitive values
- Use `@secure()` decorator for sensitive parameters
- Set `minimumTlsVersion` to 'TLS1_2' or higher
- Enable HTTPS-only traffic where applicable
- Disable public access by default

### Documentation

- Update README.md if adding new features
- Add inline comments for complex logic
- Document all parameters with `@description`
- Provide usage examples in module comments

### Parameter Files

- Create separate parameter files for each environment
- Use meaningful values that clearly indicate environment
- Never commit secrets to parameter files
- Reference Key Vault for sensitive values

## Code Review Process

All submissions require review. We use GitHub pull requests for this purpose.

### Review Criteria

- Code follows existing style and conventions
- All Bicep templates build without errors
- Documentation is updated
- Changes are minimal and focused
- Security best practices are followed

## Testing

Before submitting a pull request:

1. **Build all templates**
   ```bash
   az bicep build --file deployments/main.bicep
   ```

2. **Lint all templates**
   ```bash
   az bicep lint --file deployments/main.bicep
   ```

3. **Validate JSON syntax**
   ```bash
   jq empty parameters/dev/main.parameters.json
   ```

4. **Test deployment (optional)**
   ```bash
   az deployment group what-if \
     --resource-group test-rg \
     --template-file deployments/main.bicep \
     --parameters parameters/dev/main.parameters.json
   ```

## Questions?

If you have questions about contributing, feel free to open an issue for discussion.

Thank you for contributing!
