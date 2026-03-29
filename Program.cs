using System.Runtime;

const int mb = 1024 * 1024;
List<byte[]> dataObjects = [];
List<byte[]> fragObjects = [];

Console.WriteLine($"Total Available Memory = {GC.GetGCMemoryInfo().TotalAvailableMemoryBytes / mb}");
Console.WriteLine($"IsServerGC = {GCSettings.IsServerGC}");

try
{
    for (var i = 0; i < 5; i++)
    {
        // Create large objects
        AppendWithSize(dataObjects, 80 * mb);
        AppendWithSize(fragObjects, 16 * mb);
        DumpMemSize($"Objects added - {i}");
    }

    dataObjects.Clear();
    DumpMemSize("dataObjects cleared");
    GC.Collect();
    DumpMemSize("GC.Collect()");

    // The line below will cause OOM (note: the size must greater than the "hole")
    // dataObjects.Add(new byte[100 * mb]);
}
catch (Exception ex)
{
    Console.WriteLine("ERROR-" + ex.Message);
}

Console.ReadLine();

return;


static void DumpMemSize(string msg)
{
    var info = GC.GetGCMemoryInfo();
    var totalMemory = GC.GetTotalMemory(false);
    Console.WriteLine($"[{msg}]");
    Console.WriteLine($"  GetTotalMemory   = {totalMemory / mb}MB");
    Console.WriteLine($"  HeapSizeBytes    = {info.HeapSizeBytes / mb}MB");
    Console.WriteLine($"  FragmentedBytes  = {info.FragmentedBytes / mb}MB");
    Console.WriteLine($"  MemoryLoadBytes  = {info.MemoryLoadBytes / mb}MB");
    Console.WriteLine($"  WorkingSet       = {Environment.WorkingSet / mb}MB");
}

static void AppendWithSize(List<byte[]> list, int size)
{
    list.Add(new byte[size]);
}