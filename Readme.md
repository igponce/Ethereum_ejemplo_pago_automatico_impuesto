# Contrato interpuesto para pago IVA

Este contrato actúa como intermediario entre el pagador,
la administración, y el destinatario del pago.

Este es un contrato a modo de ejemplo.
Asumimos que tenemos una única administración a la que enviar
los pagos.

La vida real es MUCHO más compleja. Podemos encontrarnos con:

  - Facturas con varias líneas de IVA
  - Impuestos cedidos a varias administraciones (como el IVA)
  - Impuestos gravando otros impuestos (ej. Hidrocarburos + IVA) con administraciones distintas.
  - Embargos de la Agencia Tributaria, que harían que los pagos fuesen directamente a la AEAT para saldar una deuda.

Interfaces

- PagaFacturaEth(Importe, IVA)
- PagaFacturaERC20(token, Importe, IVA)

  Se envía el pago de una factura o servicio a través 
de un contrato inteligente.

  El pago puede hacerse usando Ethereum, o cualquier token ERC20.

  El importe del pago queda almacenado en el contrato para evitar
problemas de seguridad debidos a reentrada.

  Para recibir el pago, hay que solicitarlo.

- ClaimEth(addr)
- ClaimERC20(tokenr, addr)

  Manda los fondos custodiados a la dirección que solicita el pago.

