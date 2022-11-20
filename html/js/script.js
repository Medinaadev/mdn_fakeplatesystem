$(function(){

    $('.plate').css('opacity', '0').css('transition', '.5s');
    $('.plate-button').css({
        'transform': 'translate(-50%, -10%)',
        'opacity': '0'
    })

    window.addEventListener('message', function(){

        let data = event.data;

        if (data.action == 'show') {
            $('.plate').css('opacity', '1');
            $('.plate-button').css({
                'transform': 'translate(-50%, -10%)',
                'opacity': '0'
            })
            $('.plate-input-month').text(data.config.PlateMonth);
            $('.plate-input-year').text(data.config.PlateYear);
            $('.plate-input-code input').attr('maxLength', data.config.PlateLetters).val('').focus();
        }

    });

    document.onkeyup = function (data) {

        let key = data.key;

        if (key == 'Escape') {

            $('.plate').css('opacity', '0');
            $.post('https://mdn_fakeplatesystem/close');

        }

    };

    $('.plate-input-code input').on('input', function(){
        
        let plate = $(this).val();

        if (plate.length > 0) {
            $('.plate-button').css({
                'transform': 'translate(-50%, 0%)',
                'opacity': '1'
            })
        }else{
            $('.plate-button').css({
                'transform': 'translate(-50%, -10%)',
                'opacity': '0'
            })
        };

    })

    $('.plate-button').click(function(){

        let plate = $('.plate-input-code input').val();
        $('.plate').css('opacity', '0');

        $.post('https://mdn_fakeplatesystem/changePlate', JSON.stringify({plate: plate}));

    });

})