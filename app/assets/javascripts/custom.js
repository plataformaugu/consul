// Overrides and adds customized javascripts in this file
// Read more on documentation:
// * English: https://github.com/consul/consul/blob/master/CUSTOMIZE_EN.md#javascript
// * Spanish: https://github.com/consul/consul/blob/master/CUSTOMIZE_ES.md#javascript
//
//

// Advertencia para eliminar una propuesta


function palancaAdvertencia() {
    let advertencia = document.getElementById('advertencia-eliminar-propuesta');
    let estilo = document.defaultView.getComputedStyle(advertencia);
    if (estilo.display === 'none') {
        advertencia.style.display = 'block';
    }
    else {
        advertencia.style.display = 'none';
    }
}