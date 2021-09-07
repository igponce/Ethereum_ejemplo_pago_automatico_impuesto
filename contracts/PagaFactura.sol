// Pagafactura.sol
// Contrato interpuesto para pago de facturas con cobro automático de IVA

pragma solidity >=0.7.0;

import '../interfaces/IERC20.sol';

contract Pagafactura {

   address currency; // Moneda en la que aceptamos los pagos (contrato)
   address hacienda;
   uint pct;

   // Saldos a pagar para cada una de las direcciones de Ethereum
   mapping (address => uint256) private saldo;

   event Debug(string, address, address);
   event Pagado(address orig, address dest, uint256 bruto, uint256 neto, uint256 impuestos);
   event Cobrado(address dir, uint256 importe);
   
   // Necesitamos construir el contrato (instanciar)
   // Constructor

   constructor(address _tokenaddr, address _hacienda, uint _porcentaje) {
       require(_porcentaje > 0 && _hacienda != _tokenaddr && _hacienda != address(0) );
       currency = _tokenaddr;
       hacienda = _hacienda;
       pct = _porcentaje;
   }

   // Para enviar el pago, este contrato tiene que tener permiso
   function enviaPago(address destino, uint256 cantidad) public {
       require(cantidad > 0 && destino != address(0));

       address paganinni = msg.sender; // Ojo: que puede ser un contrato
       uint256 impuesto = calculaImpuesto(cantidad);

       // Tenemos que hacer una transferencia hasta este contrato interpuesto
       require (iERC20(currency).transferFrom(paganinni, address(this), cantidad));

       // Actualizamos saldos
       // Se hace de esta manera para evitar un ataque de reentrada

       uint256 para_hacienda = calculaImpuesto(cantidad);
       uint256 para_destino = cantidad - para_hacienda;

       saldo[hacienda] += para_hacienda;
       saldo[destino] += para_destino;
       
   }

   function recibePago() public returns(bool) {
       require(msg.sender == tx.origin); // No se puede desde contratos interpuestos
       uint256 importe = saldo[tx.origin];

       saldo[tx.origin] = 0;
       bool result = iERC20(currency).transfer(tx.origin, importe);

       emit Cobrado(tx.origin, importe);

       return result;
   }

   function calculaImpuesto(uint256 bruto) public returns(uint256) {
      return 0; // Ya te gustaría a ti, ya
   }

}
