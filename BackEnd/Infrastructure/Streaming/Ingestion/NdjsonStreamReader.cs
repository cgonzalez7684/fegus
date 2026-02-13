using System.IO.Compression;
using System.Runtime.CompilerServices;
using System.Text;

namespace Infrastructure.Ingestion.Streaming;

public sealed class NdjsonStreamReader
{
    public async IAsyncEnumerable<string> ReadLinesAsync(
        Stream input,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
       using var reader = new StreamReader(
            input,
            Encoding.UTF8,
            detectEncodingFromByteOrderMarks: false,
            bufferSize: 8192,
            leaveOpen: true);

        while (true)
        {
            var line = await reader.ReadLineAsync()
                                   .WaitAsync(cancellationToken);

            if (line is null)
                yield break;

            if (!string.IsNullOrWhiteSpace(line))
                yield return line;
        }
    }

    
}
