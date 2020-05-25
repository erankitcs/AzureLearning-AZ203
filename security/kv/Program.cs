﻿using System;
using System.Threading.Tasks;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.KeyVault;

namespace secrets
{
    class Program
    {
        static void Main(string[] args)
        {
            RunAsync().Wait();
        }

        private static async Task RunAsync()
        {
            var azureServiceTokenProvider1 = 
                new AzureServiceTokenProvider();
            var kvc = new KeyVaultClient(
                new KeyVaultClient.AuthenticationCallback(
                    azureServiceTokenProvider1.KeyVaultTokenCallback));

            var kvBaseUrl = "https://ankit12az203kvsecrets.vault.azure.net/";
            var secret = await kvc.GetSecretAsync(
                kvBaseUrl, "connectionString");
            System.Console.WriteLine(secret.Value);
        }
    }
}
