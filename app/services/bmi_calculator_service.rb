require "httparty"
class BmiCalculatorService
  include HTTParty
  include ExternalApiConstants

  def calculate(weight:, height:)
    url = "#{BMI_API_URL}/#{weight}/#{height}"
    resp = self.class.get(url)
    if resp.success?
      { body: resp.parsed_response }
    else
      { error: "BMI API error: #{resp.code}" }
    end
  rescue StandardError => e
    Rails.logger.error("BMI calculation failed: #{e.message}")
    { error: "BMI calculation failed: #{e.message}" }
  end
end
