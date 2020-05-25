using System;

namespace ankit.az203.storage.blobs
{
    class Program
    {
        static void Main(string[] args)
        {
            Blobs.RunAsync().Wait();
        }
    }
}