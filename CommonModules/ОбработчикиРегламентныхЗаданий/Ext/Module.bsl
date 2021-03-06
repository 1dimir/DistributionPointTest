﻿
Функция ТекстЗапроса_ЦеликомЗакрытыеПланыПоступлений()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СтатусыЗаказов.Заказ КАК Заказ
	|ПОМЕСТИТЬ ЗаказыКПоступлению
	|ИЗ
	|	РегистрСведений.СтатусыЗаказа.СрезПоследних(
	|			,
	|			Заказ В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ТаблицаЗаказов.Заказ КАК Заказ
	|				ИЗ
	|					РегистрСведений.ПланыПоступлений КАК ПланыПоступлений
	|						ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПланПоступления.Заказы КАК ТаблицаЗаказов
	|						ПО
	|							ТаблицаЗаказов.Ссылка = ПланыПоступлений.ПланПоступления)) КАК СтатусыЗаказов
	|ГДЕ
	|	СтатусыЗаказов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказа.ОжидаетсяПоступление)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланыПоступлений.ПланПоступления КАК ПланПоступления
	|ИЗ
	|	РегистрСведений.ПланыПоступлений КАК ПланыПоступлений
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланПоступления.Заказы КАК ТаблицаЗаказов
	|		ПО (ТаблицаЗаказов.Ссылка = ПланыПоступлений.ПланПоступления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗаказыКПоступлению КАК ЗаказыКПоступлению
	|		ПО (ЗаказыКПоступлению.Заказ = ТаблицаЗаказов.Заказ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланыПоступлений.ПланПоступления
	|
	|ИМЕЮЩИЕ
	|	МИНИМУМ(ЗаказыКПоступлению.Заказ ЕСТЬ NULL) = ИСТИНА";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ОчиститьПланыПоступлений() Экспорт
	
	Запрос = Новый Запрос(ТекстЗапроса_ЦеликомЗакрытыеПланыПоступлений());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			РегистрыСведений.ПланыПоступлений.Заблокировать(Выборка.ПланПоступления);
			РегистрыСведений.ПланыПоступлений.Удалить(Выборка.ПланПоступления);
		Исключение
			ОтменитьТранзакцию();
			// TODO: Запись журнала регистрации
		КонецПопытки;		
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
КонецПроцедуры
