export const environment = {
  production: false,
  baseUrl: 'http://localhost:8080',
  apiUrl: 'http://localhost:8080/deudores/200/818160570',
  AuthClientId: 'cb8fcede-1f85-4d07-b4f5-b17b205481a6', // 👈 Fegus SPA (Azure)
  AuthAuthority: 'https://login.microsoftonline.com/common',  
  ApiAZScope: 'api://6213113d-96b9-44a6-981a-10f4c542cf43/access_as_user', // 👈 Reemplaza con el Application ID URI de tu API
  AuthRedirectUri: 'http://localhost:4200/dashboard'
};