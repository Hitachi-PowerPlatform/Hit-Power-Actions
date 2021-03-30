# Hit-Power-Actions

## Description
This repository main focus is to hold the Hitachi Build Tools actions on GitHub.
A brief explanation of the actions will be provided.

## Enable Multiple Flows

This actions is responsible for enabling all the cloud flows that have their name match the filter criteria. The cloud flows must be eligible to be enabled, this means that all the connections must be valid within the cloud flow.

## Move Solution components

This action moves the components from one solution to another in the same environment. The second solution must exist in the environment already.

## Remove Active Layers

The present action removes the active layers of customizations of all the filtered cloud flows. If the cloud flow does not have a active customizations layer the action does not fail.

## Share Canvas App with Multiple users

This action allows to share a canvas app with a list of users. The user list must be on the repository with the name UserEmails.csv. This action searches for the user email on Azure Active Directory and then shares the app with the user. The users can have three different roles, can view, can view and share and can edit (owner).

## Notes

When the action.yml file input variables are secrets or passwords, these variables should be set on the GitHub secrets. No password or secret should be ever committed to the repository.
