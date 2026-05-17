namespace Application.Feactures.Loading.Commands.LoadBoxData;

public sealed record LoadBoxDataCommand(int IdCliente, long IdLoad, int MaxAttempts) : ICommand;
