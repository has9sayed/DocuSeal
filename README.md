# DocuSeal Sample

   A lightweight document management and e-signature application built with Ruby on Rails, demonstrating Daytona's development environment capabilities.

   ##  Getting Started

   ### Prerequisites
   - [Daytona](https://daytona.io/docs/getting-started) installed on your system
   - Git

   ### Open Using Daytona
   1. Install Daytona by following the [installation guide](https://daytona.io/docs/getting-started)
   2. Create the Workspace:
      \\\ash
      daytona create https://github.com/has9sayed/DocuSeal
      \\\

   ### Start the Application
   Once the workspace is created:
   \\\ash
   bundle exec rails server
   \\\

   ##  Features
   - Document template creation and management
   - Electronic signature support with customizable fields
   - PDF generation and handling
   - Secure user authentication
   - Role-based access control
   - Standardized development environment with devcontainers

   ##  Tech Stack
   - Ruby on Rails 7.1
   - PostgreSQL
   - Devise for authentication
   - WickedPDF for PDF generation
   - Development containers for consistent environments
