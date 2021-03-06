﻿
Функция ПараметрыЗаписи()
	
	Возврат Новый ПараметрыЗаписиJSON(
		ПереносСтрокJSON.Unix,
		Символы.Таб,
		Истина,
		ЭкранированиеСимволовJSON.СимволыВнеBMP,
		Истина,
		Истина,
		Истина,
		Истина,
		Истина);
	
КонецФункции

// Преобразуетс структуру данных в строку
Функция Записать(Знач СтруктураДанных) Экспорт
	
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку(ПараметрыЗаписи());
	
	ЗаписатьJSON(Запись, СтруктураДанных);
	
	Возврат Запись.Закрыть();
	
КонецФункции